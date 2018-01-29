# ISO 19110 <<Class>> FGDC
# writer output in XML

# History:
#  Stan Smith 2017-11-16 original script

require_relative 'class_identification'
require_relative 'class_quality'
require_relative 'class_spatialOrganization'
require_relative 'class_spatialReference'
require_relative 'class_dictionary'
require_relative 'class_metadataInfo'

module ADIWG
   module Mdtranslator
      module Writers
         module Fgdc

            class Fgdc

               def initialize(xml, responseObj)
                  @xml = xml
                  @hResponseObj = responseObj
               end

               def writeXML(intObj)

                  version = @hResponseObj[:translatorVersion]
                  hResourceInfo = intObj[:metadata][:resourceInfo]
                  hMetadataInfo = intObj[:metadata][:metadataInfo]

                  # classes used
                  idClass = Identification.new(@xml, @hResponseObj)
                  qualityClass = Quality.new(@xml, @hResponseObj)
                  spaceOrgClass = SpatialOrganization.new(@xml, @hResponseObj)
                  spaceRefClass = SpatialReference.new(@xml, @hResponseObj)
                  dictionaryClass = DataDictionary.new(@xml, @hResponseObj)
                  metaInfoClass = MetadataInformation.new(@xml, @hResponseObj)

                  # document head
                  metadata = @xml.instruct! :xml, encoding: 'UTF-8'
                  @xml.comment!('FGDC METADATA (FGDC-STD-001-1998)')
                  @xml.comment!('This file conforms to the Biological Data Profile (FGDC-STD-001.1-1999)')
                  @xml.comment!('The following metadata file was constructed using the ADIwg mdTranslator, http://mdtranslator.adiwg.org')
                  @xml.comment!('mdTranslator software is an open-source project of the Alaska Data Integration working group (ADIwg)')
                  @xml.comment!('mdTranslator and other metadata tools are available at https://github.com/adiwg')
                  @xml.comment!('ADIwg is not responsible for the content of this metadata record')
                  @xml.comment!('This metadata record was generated by mdTranslator ' + version + ' at ' + Time.now.to_s)

                  # metadata
                  @xml.tag!('metadata') do

                     # metadata 1 (idinfo) - identification information (required)
                     @xml.tag!('idinfo') do
                        idClass.writeXML(intObj)
                     end

                     # metadata 2 (dataqual) - data quality information
                     # currently only lineage is implemented
                     unless intObj[:metadata][:lineageInfo].empty?
                        @xml.tag!('dataqual') do
                           qualityClass.writeXML(intObj)
                        end
                     end
                     if intObj[:metadata][:lineageInfo].empty? && @hResponseObj[:writerShowTags]
                        @xml.tag!('dataqual')
                     end

                     # metadata 3 (spdoinfo) - spatial domain information
                     haveDomain = false
                     haveDomain = true unless hResourceInfo[:spatialRepresentations].empty?
                     haveDomain = true unless hResourceInfo[:spatialRepresentationTypes].empty?
                     hResourceInfo[:spatialReferenceSystems].each do |hSystem|
                        unless hSystem[:systemIdentifier].empty?
                           if hSystem[:systemIdentifier][:identifier] == 'indirect'
                              haveDomain = true
                           end
                        end
                     end
                     if haveDomain
                        @xml.tag!('spdoinfo') do
                           spaceOrgClass.writeXML(hResourceInfo)
                        end
                     elsif @hResponseObj[:writerShowTags]
                        @xml.tag!('spdoinfo')
                     end

                     # metadata 4 (spref) - spatial reference systems
                     haveSpaceRef = false
                     haveSpaceRef = true unless hResourceInfo[:spatialResolutions].empty?
                     haveSpaceRef = true unless hResourceInfo[:spatialReferenceSystems].empty?
                     if haveSpaceRef
                        @xml.tag!('spref') do
                           spaceRefClass.writeXML(hResourceInfo)
                        end
                     elsif @hResponseObj[:writerShowTags]
                        @xml.tag!('spref')
                     end

                     # metadata 5 (eainfo) - entity attribute information
                     # <- dataDictionaries[0]
                     haveDict = false
                     unless intObj[:dataDictionaries].empty?
                        hDictionary = intObj[:dataDictionaries][0]
                        unless hDictionary.empty?
                           @xml.tag!('eainfo') do
                              dictionaryClass.writeXML(hDictionary)
                           end
                           haveDict = true
                        end
                     end
                     if !haveDict && @hResponseObj[:writerShowTags]
                        @xml.tag!('eainfo')
                     end

                     # metadata 6 (distinfo) - distribution information


                     # metadata 7 (metainfo) - metadata information (required)
                     @xml.tag!('metainfo') do
                        metaInfoClass.writeXML(hMetadataInfo)
                     end

                     return metadata
                  end

               end

            end

         end
      end
   end
end
