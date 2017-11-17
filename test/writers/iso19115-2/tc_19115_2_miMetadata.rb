# MdTranslator - minitest of
# writers / iso19115_2 / class_miMetadata

# History:
#   Stan Smith 2017-01-07 original script

require 'minitest/autorun'
require 'json'
require 'rubygems'
require 'rexml/document'
require 'adiwg/mdtranslator'
require 'adiwg/mdtranslator/writers/iso19115_2/version'
include REXML

class TestWriter191152MIMetadata < MiniTest::Test

   # read the ISO 19115-2 reference file
   fname = File.join(File.dirname(__FILE__), 'resultXML', '19115_2_miMetadata.xml')
   file = File.new(fname)
   @@iso_xml = Document.new(file)

   # read the mdJson 2.0 file
   fname = File.join(File.dirname(__FILE__), 'testData', '19115_2_miMetadata.json')
   file = File.open(fname, 'r')
   @@mdJson = file.read
   file.close

   def test_19115_2_miMetadata

      aRefXML = []
      XPath.each(@@iso_xml, '//gmi:MI_Metadata') {|e| aRefXML << e}

      hResponseObj = ADIWG::Mdtranslator.translate(
         file: @@mdJson, reader: 'mdJson', writer: 'iso19115_2', showAllTags: true
      )

      translatorVersion = ADIWG::Mdtranslator::VERSION
      writerVersion = ADIWG::Mdtranslator::Writers::Iso19115_2::VERSION
      schemaVersion = Gem::Specification.find_by_name('adiwg-mdjson_schemas').version.to_s

      assert_equal 'mdJson', hResponseObj[:readerRequested]
      assert_equal '2.0.0', hResponseObj[:readerVersionRequested]
      assert_equal schemaVersion, hResponseObj[:readerVersionUsed]
      assert hResponseObj[:readerStructurePass]
      assert_empty hResponseObj[:readerStructureMessages]
      assert_equal 'normal', hResponseObj[:readerValidationLevel]
      assert hResponseObj[:readerValidationPass]
      assert_empty hResponseObj[:readerValidationMessages]
      assert hResponseObj[:readerExecutionPass]
      assert_empty hResponseObj[:readerExecutionMessages]
      assert_equal 'iso19115_2', hResponseObj[:writerRequested]
      assert_equal writerVersion, hResponseObj[:writerVersion]
      assert hResponseObj[:writerPass]
      assert_equal 'xml', hResponseObj[:writerOutputFormat]
      assert hResponseObj[:writerShowTags]
      assert_nil hResponseObj[:writerCSSlink]
      assert_equal '_000', hResponseObj[:writerMissingIdCount]
      assert_equal translatorVersion, hResponseObj[:translatorVersion]

      metadata = hResponseObj[:writerOutput]
      iso_out = Document.new(metadata)

      aCheckXML = []
      XPath.each(iso_out, '//gmi:MI_Metadata') {|e| aCheckXML << e}

      aRefXML.length.times {|i|
         assert_equal aRefXML[i].to_s.squeeze, aCheckXML[i].to_s.squeeze
      }

   end

end
