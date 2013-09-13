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
    help: 'Provide a link to the source code, if available. GitHub links, Google code, apache etc'
  'logo':
    type: 'image',
    noindex: true,
    display: 'Logo'
    help: 'Upload an image with a logo. Right now, the fist even supplied image will be selected'
  'typical use cases':
    type: 'markdown',
    display: 'Typical Use Cases'
    help: 'What are the typical use cases for this technology?  Where does it shine? You may link to blog post, stackoverflow or just type right here'
  'sweet spots':
    type: 'markdown',
    display: 'Sweet Spots'
    help: 'What are the sweet spots of this technology? This is similar to Typical Use Cases, but short and consice, no external links, like a tagline.'
  'weaknesses':
    type: 'markdown',
    display: 'Weaknesses'
    help: 'What are the weaknesses if this technology? In other words - When or in what cases should one not use it or take special care?'
  'documentation':
    type: 'markdown',
    display: 'Documentation'
    help: 'Provide a link to teh documentation site'
  'tutorials':
    type: 'markdown'
    display: 'Tutorials'
    help: 'Provide links to good tutorials that you\'d found or that you wrote'
  'stackoverflow':
    type: 'markdown'
    display: 'StackOverflow'
    help: 'Provide a link the relevant stackoverflow tags'
  'mailing lists':
    type: 'markdown'
    display: 'Mailing Lists'
    help: 'Provide link to the mailing list (or lists)'
  'irc':
    type: 'markdown'
    display: 'IRC'
    help: 'Provide a link to the IRC chanel, if exists'
  'development status':
    type: 'markdown'
    display: 'Development Status'
    help: 'What\'s the development status is? Is it stable? v2? Preview?...'
  'alternatives':
    type: 'markdown'
    display: 'Alternatives'
    help: 'What are some alternative solutions to this technology? In other words, what are the competitor technologies in the same Vertical? Technologies that propose a different solotion to the same problem. For example an alternative to Solr is ElasticSearch'
  'complement technologies':
    type: 'markdown'
    display: 'Complement Technologies'
    help: 'What are the complement technologies to this one? In other words, If you like this technology you\'d also be interested in x, y, z'
   'talks, videos, slides':
    type: 'markdown'
    display: 'Talks, Videos, Slides'
  'cheatsheet / example / demo':
    type: 'markdown'
    display: 'Cheatsheet / Examples / Demo'
   'prerequisites':
    type: 'markdown'
    display: 'Prerequisites'
    help: 'Are there any prerequisites to using this technology? This is similar to Stack, but goes to grater detail such as specific compatible versions of jQuery etc.'
   'reviews':
    type: 'markdown'
    display: 'Reviews'
    help: 'Did you find a review of this technology online? That\'s great, we want to know about this. Did you publish your review? That\'s great for us and for you, link it here!'
   'developers':
    type: 'markdown'
    display: 'Developers'
    help: 'Who\'s behind this? List names or companies. GitHub handles are greate.'
   'versioneye':
    type: 'markdown'
    display: 'VersionEye'
    help: 'Link to the VersionEye page, for example: https://www.versioneye.com/ruby/jquery-rails/'
   'twitter':
    type: 'markdown'
    display: 'Twitter'
    help: 'Link to the Twitter handle, if such exists'
   'facebook':
    type: 'markdown'
    display: 'Facebook'
    help: 'Link to the Facebook page, if such exists'
   'google+':
    type: 'markdown'
    display: 'Google+'
    help: 'Link to the Google+ handle, if such exists'
   'hello world':
    type: 'markdown'
    display: 'Hello World'
    help: 'Type a Hello World program here'
   'comments':
    type: 'markdown'
    display: 'Comments'
    help: 'Any more comments please?...'
   'more':
    type: 'markdown'
    display: 'More'
    help: 'Anythin more to add?...'
