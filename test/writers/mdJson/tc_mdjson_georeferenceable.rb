# mdJson 2.0 writer tests - georeferenceable representation

# History:
#   Stan Smith 2017-03-15 original script

require 'minitest/autorun'
require 'json/pure'
require 'adiwg-mdtranslator'
require_relative 'mdjson_test_parent'

class TestWriterGeoreferenceable < TestWriterMdJsonParent

   # get input JSON for test
   @@jsonIn = TestWriterMdJsonParent.getJson('georeferenceable.json')

   def test_schema_georeferenceable

      hIn = JSON.parse(@@jsonIn)
      hTest = hIn['metadata']['resourceInfo']['spatialRepresentation'][0]['georeferenceableRepresentation']
      errors = TestWriterMdJsonParent.testSchema(hTest, 'georeferenceableRepresentation.json')
      assert_empty errors

   end

   def test_complete_georeferenceable

      metadata = ADIWG::Mdtranslator.translate(
         file: @@jsonIn, reader: 'mdJson', validate: 'normal',
         writer: 'mdJson', showAllTags: false)

      expect = JSON.parse(@@jsonIn)
      expect = expect['metadata']['resourceInfo']['spatialRepresentation']
      got = JSON.parse(metadata[:writerOutput])
      got = got['metadata']['resourceInfo']['spatialRepresentation']

      assert_equal expect, got

   end

end
