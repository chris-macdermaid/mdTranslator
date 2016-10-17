# unpack source
# Reader - ADIwg JSON to internal data structure

# History:
#   Stan Smith 2016-10-17 refactored for mdJson 2.0
#   Stan Smith 2015-07-14 refactored to remove global namespace constants
#   Stan Smith 2015-06-22 replace global ($response) with passed in object (responseObj)
#   Stan Smith 2014-12-15 refactored to handle namespacing readers and writers
#   Stan Smith 2014-07-03 resolve require statements using Mdtranslator.reader_module
# 	Stan Smith 2013-11-26 original script

require ADIWG::Mdtranslator::Readers::MdJson.readerModule('module_citation')
require ADIWG::Mdtranslator::Readers::MdJson.readerModule('module_processStep')
require ADIWG::Mdtranslator::Readers::MdJson.readerModule('module_spatialResolution')
require ADIWG::Mdtranslator::Readers::MdJson.readerModule('module_spatialReference')

module ADIWG
    module Mdtranslator
        module Readers
            module MdJson

                module Source

                    def self.unpack(hSource, responseObj)

                        # return nil object if input is empty
                        if hSource.empty?
                            responseObj[:readerExecutionMessages] << 'Source object is empty'
                            responseObj[:readerExecutionPass] = false
                            return nil
                        end

                        # instance classes needed in script
                        intMetadataClass = InternalMetadata.new
                        intSource = intMetadataClass.newDataSource

                        # source - description (required)
                        if hSource.has_key?('description')
                            intSource[:description] = hSource['description']
                        end
                        if intSource[:description].nil? || intSource[:description] == ''
                            responseObj[:readerExecutionMessages] << 'Source attribute description is missing'
                            responseObj[:readerExecutionPass] = false
                            return nil
                        end

                        # source - source citation
                        if hSource.has_key?('sourceCitation')
                            hCitation = hSource['sourceCitation']
                            unless hCitation.empty?
                                intSource[:sourceCitation] = Citation.unpack(hCitation, responseObj)
                            end
                        end

                        # source - source metadata []
                        if hSource.has_key?('sourceMetadata')
                            aCitation = hSource['sourceMetadata']
                            aCitation.each do |item|
                                hCitation = Citation.unpack(item, responseObj)
                                unless hCitation.nil?
                                    intSource[:metadataCitation] << hCitation
                                end
                            end
                        end

                        # source - spatial resolution
                        if hSource.has_key?('spatialResolution')
                            hResolution = hSource['spatialResolution']
                            unless hResolution.empty?
                                intSource[:spatialResolution] = SpatialResolution.unpack(hResolution, responseObj)
                            end
                        end

                        # source - reference system
                        if hSource.has_key?('referenceSystem')
                            hReference = hSource['referenceSystem']
                            unless hReference.empty?
                                intSource[:referenceSystem] = SpatialReferenceSystem.unpack(hReference, responseObj)
                            end
                        end

                        # source - source steps []
                        if hSource.has_key?('sourceStep')
                            aSteps = hSource['sourceStep']
                            aSteps.each do |item|
                                hStep = ProcessStep.unpack(item, responseObj)
                                unless hStep.nil?
                                    intSource[:sourceSteps] << hStep
                                end
                            end
                        end

                        return intSource

                    end

                end

            end
        end
    end
end
