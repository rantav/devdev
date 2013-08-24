describe 'Cdn', ->
  describe 'cdnify', ->
    it 'should not fail on empty strings', ->
      expect(Cdn.cdnify('')).toBe('')
    it 'should replace the hostname', ->
      expect(Cdn.cdnify('https://www.filepicker.io/api/file/zNXPwIYRRE6ciOPNhzkN/convert?h=5&cache=true')).
        toBe('https://d16azfexq1dof6.cloudfront.net/api/file/zNXPwIYRRE6ciOPNhzkN/convert?h=5&cache=true')
