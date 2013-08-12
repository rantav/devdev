describe 'Text', ->
  describe 'markdownWithSmartLinks', ->
    it 'empty markdown should remain empty', ->
      expect(Text.markdownWithSmartLinks('')).toBe('')
    it 'non empty, but no links, markdown should remain the same', ->
      expect(Text.markdownWithSmartLinks('123')).toBe('123')
    it '/technology/123 should become [/technology/123](/technology/123)', ->
      expect(Text.markdownWithSmartLinks('/technology/123')).toBe('[/technology/123](/technology/123)')
    it ' /technology/123 should become " [/technology/123](/technology/123)"', ->
      expect(Text.markdownWithSmartLinks(' /technology/123')).toBe(' [/technology/123](/technology/123)')
    it 'xxx /technology/123 yyy should become xxx [/technology/123](/technology/123) yyy', ->
      expect(Text.markdownWithSmartLinks('xxx /technology/123 yyy')).toBe('xxx [/technology/123](/technology/123) yyy')
    it '/technology/123\\n should become [/technology/123](/technology/123)\\n', ->
      expect(Text.markdownWithSmartLinks('/technology/123\nok')).toBe('[/technology/123](/technology/123)\nok')
    it '/technology/123/456 should become [/technology/123/456](/technology/123/456)', ->
      expect(Text.markdownWithSmartLinks('/technology/123/456')).toBe('[/technology/123/456](/technology/123/456)')
  describe 'tokenize', ->
    it 'should not fail on empty string', ->
      expect(Text.tokenize('')).toEqual([''])
    it 'should not tokenize 123 as [123]', ->
      expect(Text.tokenize('123')).toEqual(['123'])
    it 'should not tokenize 123 45 as [123, 45]', ->
      expect(Text.tokenize('123 45')).toEqual(['123', '45'])
    it 'should not tokenize 123 45-67 as [123, 45, 67]', ->
      expect(Text.tokenize('123 45-67')).toEqual(['123', '45', '67'])
