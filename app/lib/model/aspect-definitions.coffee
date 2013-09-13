root = exports ? this

root.aspectDefinitions =
  'tagline':
    type: 'markdown'
    pinned: true
    display: 'Tagline'
    help: 'Tagline: Descrige the technology in one line. (You may copy from the vendor\'s site)'
  'website':
    type: 'markdown',
    pinned: true,
    display: 'Website'
    help: 'Website: paste a link to the technology\'s website, or github etc'
  'vertical':
    type: 'tags',
    pinned: true,
    datasource: 'suggestVerticals',
    multiplicity: 'single-per-user',
    noindex: true,
    display: 'Vertical'
    help: 'A Vertical describes The Problem this technology solves. Is it a search engine? It it an imaging library? A JavaScript library for Markdown? Provide a set of tags that define the problem space, so that it\'s easy to understand What Problem does it solve'
  'stack':
    type: 'tags',
    pinned: true,
    datasource: 'suggestStacks',
    multiplicity: 'single-per-user',
    noindex: true,
    display: 'Stack'
    help: 'A Stack defines How the technology solves the problem defined by the Vertical. Is this a javascript lib? Java? Ruby? Ruby and RoR? Javascript with jQuery? A SaaS? Provide a set of tags that explains which stack does this technology work well with'
  'source code':
    type: 'markdown',
    display: 'Source Code'
  'logo':
    type: 'image',
    noindex: true,
    display: 'Logo'
    help: 'Upload an image with a logo. Right now, the fist even supplied image will be selected'
  'typical use cases':
    type: 'markdown',
    display: 'Typical Use Cases'
    help: 'Explain what are the typical use cases for this technology, where does it shine? You may link to blog post, stackoverflow or just type right here'
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
