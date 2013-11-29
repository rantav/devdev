@base64decode = (encoded) -> new Buffer(encoded || '', 'base64').toString('utf8')
@base64encode = (unencoded) -> new Buffer(unencoded || '').toString('base64')