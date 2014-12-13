# unpack data identification
# Reader - ADIwg JSON V1 to internal data structure

# History:
# 	Stan Smith 2013-08-22 original script
# 	Stan Smith 2013-11-04 extents
# 	Stan Smith 2013-11-14 legal constraints
# 	Stan Smith 2013-11-20 taxonomy
# 	Stan Smith 2013-11-25 resource specific usage
# 	Stan Smith 2013-11-26 spatial resolution
#   Stan Smith 2014-04-25 revised to support json schema version 0.3.0
#   Stan Smith 2014-05-28 added resource identifier to citation json schema 0.5.0
#   Stan Smith 2014-07-03 resolve require statements using Mdtranslator.reader_module
#   Stan Smith 2014-08-18 moved resourceIdentifier to citation module schema 0.6.0
#   Stan Smith 2014-09-03 added spatial reference system module for 0.7.0
#   Stan Smith 2014-10-29 added support for resource time period
#   Stan Smith 2014-11-06 added resourceType for 0.9.0

require ADIWG::Mdtranslator.reader_module('module_citation', $response[:readerVersionUsed])
require ADIWG::Mdtranslator.reader_module('module_resourceIdentifier', $response[:readerVersionUsed])
require ADIWG::Mdtranslator.reader_module('module_responsibleParty', $response[:readerVersionUsed])
require ADIWG::Mdtranslator.reader_module('module_resourceFormat', $response[:readerVersionUsed])
require ADIWG::Mdtranslator.reader_module('module_descriptiveKeyword', $response[:readerVersionUsed])
require ADIWG::Mdtranslator.reader_module('module_resourceMaintenance', $response[:readerVersionUsed])
require ADIWG::Mdtranslator.reader_module('module_resourceSpecificUsage', $response[:readerVersionUsed])
require ADIWG::Mdtranslator.reader_module('module_browseGraphic', $response[:readerVersionUsed])
require ADIWG::Mdtranslator.reader_module('module_legalConstraint', $response[:readerVersionUsed])
require ADIWG::Mdtranslator.reader_module('module_securityConstraint', $response[:readerVersionUsed])
require ADIWG::Mdtranslator.reader_module('module_taxonomy', $response[:readerVersionUsed])
require ADIWG::Mdtranslator.reader_module('module_resolution', $response[:readerVersionUsed])
require ADIWG::Mdtranslator.reader_module('module_extent', $response[:readerVersionUsed])
require ADIWG::Mdtranslator.reader_module('module_dataQuality', $response[:readerVersionUsed])
require ADIWG::Mdtranslator.reader_module('module_spatialReference', $response[:readerVersionUsed])
require ADIWG::Mdtranslator.reader_module('module_timePeriod', $response[:readerVersionUsed])

module Md_ResourceInfo

    def self.unpack(hResourceInfo)

        # instance classes needed in script
        intMetadataClass = InternalMetadata.new
        intResInfo = intMetadataClass.newResourceInfo

        # resource information - resource type
        if hResourceInfo.has_key?('resourceType')
            s = hResourceInfo['resourceType']
            if s != ''
                intResInfo[:resourceType] = s
            end
        end

        # resource information - citation
        if hResourceInfo.has_key?('citation')
            hCitation = hResourceInfo['citation']
            unless hCitation.empty?
                intResInfo[:citation] = Md_Citation.unpack(hCitation)
            end
        end

        # resource information - resource time period
        if hResourceInfo.has_key?('resourceTimePeriod')
            hResPeriod = hResourceInfo['resourceTimePeriod']
            unless hResPeriod.empty?
                intResInfo[:timePeriod] = Md_TimePeriod.unpack(hResPeriod)
            end
        end

        # resource information - point of contact
        if hResourceInfo.has_key?('pointOfContact')
            aPOC = hResourceInfo['pointOfContact']
            unless aPOC.empty?
                aPOC.each do |rParty|
                    intResInfo[:pointsOfContact] << Md_ResponsibleParty.unpack(rParty)
                end
            end
        end

        # resource information - abstract
        if hResourceInfo.has_key?('abstract')
            s = hResourceInfo['abstract']
            if s != ''
                intResInfo[:abstract] = s
            end
        end

        # resource information - short abstract
        if hResourceInfo.has_key?('shortAbstract')
            s = hResourceInfo['shortAbstract']
            if s != ''
                intResInfo[:shortAbstract] = s
            end
        end

        # resource information - status
        if hResourceInfo.has_key?('status')
            s = hResourceInfo['status']
            if s != ''
                intResInfo[:status] = s
            end
        end

        # resource information - has mappable location
        if hResourceInfo.has_key?('hasMapLocation')
            s = hResourceInfo['hasMapLocation']
            if s != ''
                intResInfo[:hasMapLocation?] = s
            end
        end

        # resource information - has data available
        if hResourceInfo.has_key?('hasDataAvailable')
            s = hResourceInfo['hasDataAvailable']
            if s != ''
                intResInfo[:hasDataAvailable?] = s
            end
        end

        # resource information - language
        if hResourceInfo.has_key?('language')
            aLanguage = hResourceInfo['language']
            unless aLanguage.empty?
                aLanguage.each do |language|
                    intResInfo[:resourceLanguages] << language
                end
            end
        end

        # resource information - purpose
        if hResourceInfo.has_key?('purpose')
            s = hResourceInfo['purpose']
            if s != ''
                intResInfo[:purpose] = s
            end
        end

        # resource information - credit
        if hResourceInfo.has_key?('credit')
            aCredits = hResourceInfo['credit']
            unless aCredits.empty?
                aCredits.each do |credit|
                    intResInfo[:credits] << credit
                end
            end
        end

        # resource information - topic category
        if hResourceInfo.has_key?('topicCategory')
            aTopics = hResourceInfo['topicCategory']
            unless aTopics.empty?
                aTopics.each do |topic|
                    intResInfo[:topicCategories] << topic
                end
            end
        end

        # resource information - environment description
        if hResourceInfo.has_key?('environmentDescription')
            s = hResourceInfo['environmentDescription']
            if s != ''
                intResInfo[:environmentDescription] = s
            end
        end

        # resource information - resource format
        if hResourceInfo.has_key?('resourceNativeFormat')
            aResFormat = hResourceInfo['resourceNativeFormat']
            unless aResFormat.empty?
                aResFormat.each do |hResFormat|
                    intResInfo[:resourceFormats] << Md_ResourceFormat.unpack(hResFormat)
                end
            end
        end

        # resource information - descriptive keywords
        if hResourceInfo.has_key?('keyword')
            aDesKeywords = hResourceInfo['keyword']
            unless aDesKeywords.empty?
                aDesKeywords.each do |hDesKeyword|
                    intResInfo[:descriptiveKeywords] << Md_DescriptiveKeyword.unpack(hDesKeyword)
                end
            end
        end

        # resource information - resource maintenance
        if hResourceInfo.has_key?('resourceMaintenance')
            aResMaint = hResourceInfo['resourceMaintenance']
            unless aResMaint.empty?
                aResMaint.each do |hResource|
                    intResInfo[:resourceMaint] << Md_ResourceMaintenance.unpack(hResource)
                end
            end
        end

        # resource information - resource specific usage
        if hResourceInfo.has_key?('resourceSpecificUsage')
            aResUses = hResourceInfo['resourceSpecificUsage']
            unless aResUses.empty?
                aResUses.each do |hUsage|
                    intResInfo[:resourceUses] << Md_ResourceSpecificUsage.unpack(hUsage)
                end
            end
        end

        # resource information - graphic overview
        if hResourceInfo.has_key?('graphicOverview')
            aBrowseGraph = hResourceInfo['graphicOverview']
            unless aBrowseGraph.empty?
                aBrowseGraph.each do |hBGraphic|
                    intResInfo[:graphicOverview] << Md_BrowseGraphic.unpack(hBGraphic)
                end
            end
        end

        # resource information - use constraints
        if hResourceInfo.has_key?('constraint')
            hConstraint = hResourceInfo['constraint']

            # resource information - resource constraints - use
            if hConstraint.has_key?('useLimitation')
                aUseLimits = hConstraint['useLimitation']
                unless aUseLimits.empty?
                    aUseLimits.each do |useLimit|
                        intResInfo[:useConstraints] << useLimit
                    end
                end
            end

            # resource information - resource constraints - legal
            if hConstraint.has_key?('legalConstraint')
                aLegalCons = hConstraint['legalConstraint']
                unless aLegalCons.empty?
                    aLegalCons.each do |hLegalCon|
                        intResInfo[:legalConstraints] << Md_LegalConstraints.unpack(hLegalCon)
                    end
                end
            end

            # resource information - resource constraints - security
            if hConstraint.has_key?('securityConstraint')
                aSecurityCons = hConstraint['securityConstraint']
                unless aSecurityCons.empty?
                    aSecurityCons.each do |hSecurityCon|
                        intResInfo[:securityConstraints] << Md_SecurityConstraints.unpack(hSecurityCon)
                    end
                end
            end

        end

        # resource information - taxonomy
        if hResourceInfo.has_key?('taxonomy')
            hTaxonomy = hResourceInfo['taxonomy']
            unless hTaxonomy.empty?
                intResInfo[:taxonomy] = Md_Taxonomy.unpack(hTaxonomy)
            end
        end

        # resource information - spatial reference systems
        if hResourceInfo.has_key?('spatialReferenceSystem')
            hSpatialRef = hResourceInfo['spatialReferenceSystem']
            unless hSpatialRef.empty?
                intResInfo[:spatialReferenceSystem] = Md_SpatialReferenceSystem.unpack(hSpatialRef)
            end
        end

        # resource information - spatial representation type
        if hResourceInfo.has_key?('spatialRepresentation')
            aSpatialType = hResourceInfo['spatialRepresentation']
            unless aSpatialType.empty?
                aSpatialType.each do |spType|
                    intResInfo[:spatialRepresentationTypes] << spType
                end
            end
        end

        # resource information - spatial resolution
        if hResourceInfo.has_key?('spatialResolution')
            aSpRes = hResourceInfo['spatialResolution']
            unless aSpRes.empty?
                aSpRes.each do |hResolution|
                    intResInfo[:spatialResolutions] << Md_Resolution.unpack(hResolution)
                end
            end
        end

        # resource information - extent
        if hResourceInfo.has_key?('extent')
            aExtents = hResourceInfo['extent']
            unless aExtents.empty?
                aExtents.each do |hExtent|
                    intResInfo[:extents] << Md_Extent.unpack(hExtent)
                end
            end
        end

        # resource information - data quality information
        if hResourceInfo.has_key?('dataQualityInfo')
            aDataQual = hResourceInfo['dataQualityInfo']
            unless aDataQual.empty?
                aDataQual.each do |hDQ|
                    intResInfo[:dataQualityInfo] << Md_DataQuality.unpack(hDQ)
                end
            end
        end

        # resource information - supplemental info
        if hResourceInfo.has_key?('supplementalInfo')
            s = hResourceInfo['supplementalInfo']
            if s != ''
                intResInfo[:supplementalInfo] = s
            end
        end

        return intResInfo
    end

end
