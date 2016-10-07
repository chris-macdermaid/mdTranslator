# unpack a data dictionary entity
# Reader - mdJson to internal data structure

# History:
#   Stan Smith 2016-10-07 refactored for mdJson 2.0
#   Stan Smith 2015-07-24 added error reporting of missing items
#   Stan Smith 2015-07-14 refactored to remove global namespace constants
#   Stan Smith 2015-06-22 replace global ($response) with passed in object (responseObj)
#   Stan Smith 2015-02-17 add entity aliases
#   Stan Smith 2014-12-15 refactored to handle namespacing readers and writers
# 	Stan Smith 2013-12-01 original script

require ADIWG::Mdtranslator::Readers::MdJson.readerModule('module_entityIndex')
require ADIWG::Mdtranslator::Readers::MdJson.readerModule('module_entityAttribute')
require ADIWG::Mdtranslator::Readers::MdJson.readerModule('module_entityForeignKey')

module ADIWG
    module Mdtranslator
        module Readers
            module MdJson

                module Entity

                    def self.unpack(hEntity, responseObj)

                        # return nil object if input is empty
                        if hEntity.empty?
                            responseObj[:readerExecutionMessages] << 'Entity object is empty'
                            responseObj[:readerExecutionPass] = false
                            return nil
                        end

                        # instance classes needed in script
                        intMetadataClass = InternalMetadata.new
                        intEntity = intMetadataClass.newEntity

                        # data entity - id (required)
                        if hEntity.has_key?('entityId')
                            intEntity[:entityId] = hEntity['entityId']
                        end
                        if intEntity[:entityId].nil? || intEntity[:entityId] == ''
                            responseObj[:readerExecutionMessages] << 'Data Dictionary entity ID is missing'
                            responseObj[:readerExecutionPass] = false
                            return nil
                        end

                        # data entity - name
                        if hEntity.has_key?('commonName')
                            if  hEntity['commonName'] != ''
                                intEntity[:entityName] =  hEntity['commonName']
                            end
                        end

                        # data entity - code (required)
                        if hEntity.has_key?('codeName')
                            intEntity[:entityCode] = hEntity['codeName']
                        end
                        if intEntity[:entityCode].nil? || intEntity[:entityCode] == ''
                            responseObj[:readerExecutionMessages] << 'Data Dictionary entity code name is missing'
                            responseObj[:readerExecutionPass] = false
                            return nil
                        end

                        # data entity - alias []
                        if hEntity.has_key?('alias')
                            hEntity['alias'].each do |item|
                                if item != ''
                                    intEntity[:entityAlias] << item
                                end
                            end
                        end

                        # data entity - definition (required)
                        if hEntity.has_key?('definition')
                            intEntity[:entityDefinition] = hEntity['definition']
                        end
                        if intEntity[:entityDefinition].nil? || intEntity[:entityDefinition] == ''
                            responseObj[:readerExecutionMessages] << 'Data Dictionary entity definition is missing'
                            responseObj[:readerExecutionPass] = false
                            return nil
                        end

                        # data entity - primary key (NOT required)
                        if hEntity.has_key?('primaryKeyAttributeCodeName')
                            hEntity['primaryKeyAttributeCodeName'].each do |item|
                                if item != ''
                                    intEntity[:primaryKey] << item
                                end
                            end
                        end

                        # data entity - indexes []
                        if hEntity.has_key?('index')
                            hEntity['index'].each do |hIndex|
                                unless hIndex.empty?
                                    intEntity[:indexes] << EntityIndex.unpack(hIndex, responseObj)
                                end
                            end
                        end

                        # data entity - attributes []
                        if hEntity.has_key?('attribute')
                            hEntity['attribute'].each do |hAttribute|
                                unless hAttribute.empty?
                                    intEntity[:attributes] << EntityAttribute.unpack(hAttribute, responseObj)
                                end
                            end
                        end

                        # data entity - foreign keys []
                        if hEntity.has_key?('foreignKey')
                            hEntity['foreignKey'].each do |hFKey|
                                unless hFKey.empty?
                                    intEntity[:foreignKeys] << EntityForeignKey.unpack(hFKey, responseObj)
                                end
                            end
                        end

                        return intEntity

                    end

                end

            end
        end
    end
end
