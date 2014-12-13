# ISO <<Class>> FC_FeatureType
# writer output in XML

# History:
# 	Stan Smith 2014-12-02 original script

require 'class_featureConstraint'
require 'class_featureAttribute'

class FC_FeatureType

    def initialize(xml)
        @xml = xml
    end

    def writeXML(hEntity)

        # classes used in FC_FeatureType
        fConClass = FC_Constraint.new(@xml)
        fAttClass = FC_FeatureAttribute.new(@xml)

        # create and identity for the entity
        $idCount = $idCount.succ
        entityID = 'entity' + $idCount
        @xml.tag!('gfc:FC_FeatureType', {'id' => entityID}) do

            # feature type - type name - required
            # use entity common name
            s = hEntity[:entityName]
            if !s.nil?
                @xml.tag!('gfc:typeName') do
                    @xml.tag!('gco:LocalName', s)
                end
            else
                @xml.tag!('gfc:typeName', {'gco:nilReason' => 'missing'})
            end

            # feature type - definition
            s = hEntity[:entityDefinition]
            if !s.nil?
                @xml.tag!('gfc:definition') do
                    @xml.tag!('gco:CharacterString', s)
                end
            elsif $showAllTags
                @xml.tag!('gfc:definition')
            end

            # feature type - code
            # use entity code name
            s = hEntity[:entityCode]
            if !s.nil?
                @xml.tag!('gfc:code') do
                    @xml.tag!('gco:CharacterString', s)
                end
            elsif $showAllTags
                @xml.tag!('gfc:code')
            end

            # feature type - isAbstract - required
            # defaulted to false, value not available in internal object
            @xml.tag!('gfc:isAbstract') do
                @xml.tag!('gco:Boolean', 'false')
            end

            # feature type - feature catalogue - required
            # 'role that links this feature type to the feature catalogue that contains it'
            # confusing, allow definition of another feature catalogue here
            # just set to nilReason = 'inapplicable' (recommended by NOAA)
            @xml.tag!('gfc:featureCatalogue', {'gco:nilReason' => 'inapplicable'})

            # feature type - constrained by
            # use to define primary key, foreign keys, and indexes
            # pass primary key
            aPKs = hEntity[:primaryKey]
            if !aPKs.empty?
                @xml.tag!('gfc:constrainedBy') do
                    fConClass.writeXML('pk', aPKs)
                end
            elsif $showAllTags
                @xml.tag!('gfc:constrainedBy')
            end

            # pass indexes
            aIndexes = hEntity[:indexes]
            if !aIndexes.empty?
                aIndexes.each do |hIndex|
                    @xml.tag!('gfc:constrainedBy') do
                        fConClass.writeXML('index', hIndex)
                    end
                end
            end

            # pass foreign keys
            aFKs = hEntity[:foreignKeys]
            if !aFKs.empty?
                aFKs.each do |hFK|
                    @xml.tag!('gfc:constrainedBy') do
                        fConClass.writeXML('fk', hFK)
                    end
                end
            end

            # feature type - character of characteristics
            # used to define entity attributes
            aAttributes = hEntity[:attributes]
            if !aAttributes.empty?
                aAttributes.each do |hAttribute|
                    @xml.tag!('gfc:carrierOfCharacteristics') do
                        fAttClass.writeXML(hAttribute)
                    end
                end
            elsif $showAllTags
                @xml.tag!('gfc:carrierOfCharacteristics')
            end

        end

    end

end
