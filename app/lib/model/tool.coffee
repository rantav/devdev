class @Tool extends Model
  @_collection: new Meteor.Collection('tools', transform: (data) => @modelize(data))

  @modelize: (data) -> new Tool(data)