root = exports ? this

root.aspectDefinitions =
  'tagline':
    type: 'markdown',
    pinned: true,
    display: 'Tagline'
  'website':
    type: 'markdown',
    pinned: true,
    display: 'Website'
  'vertical':
    type: 'tags',
    pinned: true,
    datasource: 'suggestVerticals',
    multiplicity: 'single-per-user',
    noindex: true,
    display: 'Vertical'
  'stack':
    type: 'tags',
    pinned: true,
    datasource: 'suggestStacks',
    multiplicity: 'single-per-user',
    noindex: true,
    display: 'Stack'
  'source code':
    type: 'markdown',
    display: 'Source Code'
  'logo':
    type: 'image',
    noindex: true,
    display: 'Logo'
  'typical use cases':
    type: 'markdown',
    display: 'Typical Use Cases'
  'sweet spots':
    type: 'markdown',
    display: 'Sweet Spots'
  'weaknesses':
    type: 'markdown',
    display: 'Weaknesses'
  'documentation':
    type: 'markdown',
    display: 'Documentation'
  'tutorials':
    type: 'markdown',
    display: 'Tutorials'
  'stackoverflow':
    type: 'markdown',
    display: 'StackOverflow'
  'mailing lists':
    type: 'markdown',
    display: 'Mailing Lists'
  'irc':
    type: 'markdown',
    display: 'IRC'
  'development status':
    type: 'markdown',
    display: 'Development Status'
  'used by':
    type: 'markdown',
    display: 'Used By'
  'alternatives':
    type: 'markdown',
    display: 'Alternatives'
  'complement technologies':
    type: 'markdown',
    display: 'Complement Technologies'
   'talks, videos, slides':
    type: 'markdown',
    display: 'Talks, Videos, Slides'
  'cheatsheet / example / demo':
    type: 'markdown',
    display: 'Cheatsheet / Examples / Demo'
   'prerequisites':
    type: 'markdown',
    display: 'Prerequisites'
   'reviews':
    type: 'markdown',
    display: 'Reviews'
   'developers':
    type: 'markdown',
    display: 'Developers'
   'versioneye':
    type: 'markdown',
    display: 'VersionEye'
   'twitter':
    type: 'markdown',
    display: 'Twitter'
   'facebook':
    type: 'markdown',
    display: 'Facebook'
   'google+':
    type: 'markdown',
    display: 'Google+'
   'hello world':
    type: 'markdown',
    display: 'Hello World'
   'comments':
    type: 'markdown',
    display: 'Comments'
   'more':
    type: 'markdown',
    display: 'More'
