# MdTranslator - minitest of
# writers / iso19115_2 / class_geometricObject

# History:
#  Stan Smith 2019-04-26 original script

require_relative '../../helpers/mdJson_hash_objects'
require_relative '../../helpers/mdJson_hash_functions'
require_relative 'iso19115_2_test_parent'

class TestWriter191152GeometricObject < TestWriter191152Parent

   # instance classes needed in script
   TDClass = MdJsonHashWriter.new

   # build mdJson test file in hash
   mdHash = TDClass.base

   hVectorRep = TDClass.build_vectorRepresentation_full
   mdHash[:metadata][:resourceInfo][:spatialRepresentation] = []
   mdHash[:metadata][:resourceInfo][:spatialRepresentation] << {vectorRepresentation: hVectorRep}

   @@mdHash = mdHash

   def test_geometricObject_complete

      hIn = Marshal::load(Marshal.dump(@@mdHash))

      hReturn = TestWriter191152Parent.run_test(hIn, '19115_2_geometricObject',
                                                '//gmd:geometricObjects[1]',
                                                '//gmd:geometricObjects', 0)

      assert_equal hReturn[0], hReturn[1]
      assert hReturn[2]
      assert_empty hReturn[3]

   end

   def test_geometricObject_elements

      hIn = Marshal::load(Marshal.dump(@@mdHash))

      # empty elements
      hVector = hIn[:metadata][:resourceInfo][:spatialRepresentation][0][:vectorRepresentation][:vectorObject][0]
      hVector[:objectCount] = ''

      hReturn = TestWriter191152Parent.run_test(hIn, '19115_2_geometricObject',
                                                '//gmd:geometricObjects[2]',
                                                '//gmd:geometricObjects', 0)

      assert_equal hReturn[0], hReturn[1]
      assert hReturn[2]
      assert_empty hReturn[3]

      # missing elements
      hVector.delete(:objectCount)

      hReturn = TestWriter191152Parent.run_test(hIn, '19115_2_geometricObject',
                                                '//gmd:geometricObjects[2]',
                                                '//gmd:geometricObjects', 0)

      assert_equal hReturn[0], hReturn[1]
      assert hReturn[2]
      assert_empty hReturn[3]

   end

end
