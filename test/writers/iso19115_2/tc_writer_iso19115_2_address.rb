# MdTranslator - minitest of
# writer / iso19115_2 / class_address

# History:
# Stan Smith 2014-12-22 original script

require 'minitest/autorun'
require 'builder'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require 'adiwg/mdtranslator/writers/iso19115_2/classes/class_address'

class TestWriter191152Address < MiniTest::Test

    # empty response object to pass to writer
    @@responseObj = {}

    # build the internal object structure to pass to writer
    intMetadataClass = InternalMetadata.new
    @@intAdd = intMetadataClass.newAddress

    @@intAdd[:deliveryPoints] = %w[deliveryPoint1 deliveryPoint2]
    @@intAdd[:city] = 'city'
    @@intAdd[:adminArea] = 'administrativeArea'
    @@intAdd[:postalCode] = 'postalCode'
    @@intAdd[:country] = 'country'
    @@intAdd[:eMailList] = %w[example1@example.com example2@example.com]

    # set namespace
    @@NameSpace = ADIWG::Mdtranslator::Writers::Iso19115_2

    def test_complete_address_object

        hIn = @@intAdd.clone
        @@responseObj[:writerShowTags] = false

        # create instance of writer class
        xmlResult = Builder::XmlMarkup.new(indent: 3)
        addClass = @@NameSpace::CI_Address.new(xmlResult, @@responseObj)

        # assign xml results to a string 'xmlExpect'
        xml = Builder::XmlMarkup.new(indent: 3)
        xmlExpect = xml.tag!('gmd:CI_Address') do
            xml.tag!('gmd:deliveryPoint') do
                xml.tag!('gco:CharacterString','deliveryPoint1')
            end
            xml.tag!('gmd:deliveryPoint') do
                xml.tag!('gco:CharacterString','deliveryPoint2')
            end
            xml.tag!('gmd:city') do
                xml.tag!('gco:CharacterString','city')
            end
            xml.tag!('gmd:administrativeArea') do
                xml.tag!('gco:CharacterString','administrativeArea')
            end
            xml.tag!('gmd:postalCode') do
                xml.tag!('gco:CharacterString','postalCode')
            end
            xml.tag!('gmd:country') do
                xml.tag!('gco:CharacterString','country')
            end
            xml.tag!('gmd:electronicMailAddress') do
                xml.tag!('gco:CharacterString','example1@example.com')
            end
            xml.tag!('gmd:electronicMailAddress') do
                xml.tag!('gco:CharacterString','example2@example.com')
            end
        end

        assert_equal xmlExpect, addClass.writeXML(hIn)
    end

    def test_missing_deliveryPoint_address_element

        @@responseObj[:writerShowTags] = false

        # create instance of writer class
        xmlResult = Builder::XmlMarkup.new(indent: 3)
        addClass = @@NameSpace::CI_Address.new(xmlResult, @@responseObj)

        hIn = @@intAdd.clone
        hIn[:deliveryPoints] = []

        # assign xml results to a string 'xmlExpect'
        # expect electronicMailAddress only
        xml = Builder::XmlMarkup.new(indent: 3)
        xmlExpect = xml.tag!('gmd:CI_Address') do
            xml.tag!('gmd:electronicMailAddress') do
                xml.tag!('gco:CharacterString','example1@example.com')
            end
            xml.tag!('gmd:electronicMailAddress') do
                xml.tag!('gco:CharacterString','example2@example.com')
            end
        end

        assert_equal xmlExpect, addClass.writeXML(hIn)
    end

    def test_missing_deliveryPoint_address_element_showEmpty

        @@responseObj[:writerShowTags] = true

        # create instance of writer class
        xmlResult = Builder::XmlMarkup.new(indent: 3)
        addClass = @@NameSpace::CI_Address.new(xmlResult, @@responseObj)

        hIn = @@intAdd.clone
        hIn[:deliveryPoints] = []

        # assign xml results to a string 'xmlExpect'
        # expect electronicMailAddress only
        # show all others as empty tags
        xml = Builder::XmlMarkup.new(indent: 3)
        xmlExpect = xml.tag!('gmd:CI_Address') do
            xml.tag!('gmd:deliveryPoint')
            xml.tag!('gmd:city')
            xml.tag!('gmd:administrativeArea')
            xml.tag!('gmd:postalCode')
            xml.tag!('gmd:country')
            xml.tag!('gmd:electronicMailAddress') do
                xml.tag!('gco:CharacterString','example1@example.com')
            end
            xml.tag!('gmd:electronicMailAddress') do
                xml.tag!('gco:CharacterString','example2@example.com')
            end
        end

        assert_equal xmlExpect, addClass.writeXML(hIn)
    end

    def test_missing_electronic_address_element

        @@responseObj[:writerShowTags] = false

        # create instance of writer class
        xmlResult = Builder::XmlMarkup.new(indent: 3)
        addClass = @@NameSpace::CI_Address.new(xmlResult, @@responseObj)

        hIn = @@intAdd.clone
        hIn[:eMailList] = []

        # assign xml results to a string 'xmlExpect'
        # expect electronicMailAddress only
        xml = Builder::XmlMarkup.new(indent: 3)
        xmlExpect = xml.tag!('gmd:CI_Address') do
            xml.tag!('gmd:deliveryPoint') do
                xml.tag!('gco:CharacterString','deliveryPoint1')
            end
            xml.tag!('gmd:deliveryPoint') do
                xml.tag!('gco:CharacterString','deliveryPoint2')
            end
            xml.tag!('gmd:city') do
                xml.tag!('gco:CharacterString','city')
            end
            xml.tag!('gmd:administrativeArea') do
                xml.tag!('gco:CharacterString','administrativeArea')
            end
            xml.tag!('gmd:postalCode') do
                xml.tag!('gco:CharacterString','postalCode')
            end
            xml.tag!('gmd:country') do
                xml.tag!('gco:CharacterString','country')
            end
        end

        assert_equal xmlExpect, addClass.writeXML(hIn)
    end

    def test_missing_electronic_address_element_showEmpty

        @@responseObj[:writerShowTags] = true

        # create instance of writer class
        xmlResult = Builder::XmlMarkup.new(indent: 3)
        addClass = @@NameSpace::CI_Address.new(xmlResult, @@responseObj)

        hIn = @@intAdd.clone
        hIn[:eMailList] = []

        # assign xml results to a string 'xmlExpect'
        # expect electronicMailAddress only
        xml = Builder::XmlMarkup.new(indent: 3)
        xmlExpect = xml.tag!('gmd:CI_Address') do
            xml.tag!('gmd:deliveryPoint') do
                xml.tag!('gco:CharacterString','deliveryPoint1')
            end
            xml.tag!('gmd:deliveryPoint') do
                xml.tag!('gco:CharacterString','deliveryPoint2')
            end
            xml.tag!('gmd:city') do
                xml.tag!('gco:CharacterString','city')
            end
            xml.tag!('gmd:administrativeArea') do
                xml.tag!('gco:CharacterString','administrativeArea')
            end
            xml.tag!('gmd:postalCode') do
                xml.tag!('gco:CharacterString','postalCode')
            end
            xml.tag!('gmd:country') do
                xml.tag!('gco:CharacterString','country')
            end
            xml.tag!('gmd:electronicMailAddress')
        end

        assert_equal xmlExpect, addClass.writeXML(hIn)
    end

    def test_empty_address_object

        # create instance of writer class
        xmlResult = Builder::XmlMarkup.new(indent: 3)
        addClass = @@NameSpace::CI_Address.new(xmlResult, @@responseObj)

        # create and empty address object
        intMetadataClass = InternalMetadata.new
        emptyAdd = intMetadataClass.newAddress

        assert_nil addClass.writeXML(emptyAdd)
    end

    def test_nil_address_object

        # create instance of writer class
        xmlResult = Builder::XmlMarkup.new(indent: 3)
        addClass = @@NameSpace::CI_Address.new(xmlResult, @@responseObj)

        assert_nil addClass.writeXML(nil)
    end

end
