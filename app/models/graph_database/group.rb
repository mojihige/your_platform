class GraphDatabase::Group < GraphDatabase::Node

  def group
    @object
  end

  def node_label
    "Group"
  end

  def properties
    {id: group.id, name: group.name.to_s, type: group.type.to_s}
  end

  def get_member_ids
    neo.execute_query("
      match path = (group:Group {id: #{group.id}})-[:HAS_SUBGROUP*]->(g:Group)-[m:MEMBERSHIP]->(users:User)
      where not g.type = 'OfficerGroup'
      and m.valid_to = ''
      return distinct(users.id)
      union
      match path = (group:Group {id: #{group.id}})-[m:MEMBERSHIP]->(users:User)
      where m.valid_to = ''
      return distinct(users.id)
    ")['data'].flatten
  end

  def self.get_member_ids(group)
    self.new(group).get_member_ids
  end

  def self.get_descendant_group_ids(group)
    neo.execute_query("
      match (parent:Group {id: #{group.id}})-[:HAS_SUBGROUP*]->(groups:Group)
      return groups.id
    ")['data'].flatten
  end

  #def self.get_descendant_groups(group)
  #  ::Group.find get_descendant_group_ids(group)
  #end

  def self.create_group_id_index
    # In order to make finding groups by id faster.
    neo.create_schema_index "Group", ["id"]
  end


end