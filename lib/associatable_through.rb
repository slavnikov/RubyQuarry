require_relative 'associatable'

module Associatable

  def has_one_through(name, through_name, source_name)

    define_method(name) do
      # extract the relevant association options from the classes
      t_opts = self.class.assoc_options[through_name]
      s_opts = t_opts.model_class.assoc_options[source_name]

      # extract the relevant information about the through class
      t_tbl = t_opts.table_name
      t_pk = t_opts.primary_key

      # extract the relevant infomration about the source class
      s_tbl = s_opts.table_name
      s_fk = s_opts.foreign_key
      s_pk = s_opts.primary_key

      # extract the necessary key value
      t_fk = t_opts.foreign_key
      own_fk_value = self.send(t_fk)

      response = DBConnection.execute(<<-SQL )
        SELECT
          #{s_tbl}.*
        FROM
          #{t_tbl}
        JOIN
          #{s_tbl}
        ON
          #{t_tbl}.#{s_fk} = #{s_tbl}.#{s_pk}
        WHERE
          #{t_tbl}.#{t_pk} = #{own_fk_value}
      SQL

      s_opts.model_class.parse_all(response).first
    end
  end
end
