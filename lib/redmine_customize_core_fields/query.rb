require_dependency 'query'

module RedmineCustomizeCoreFields
  module Query
    def name_matches_disabled_fields? disabled_fields, name
      variations = [name, "#{name}_id", name.sub(/^total_/, '')]
      (disabled_fields & variations).any?
    end

    def available_filters
      filters = super
      disabled_fields = project.present? ? project.disabled_core_fields : []
      filters.reject{|o| name_matches_disabled_fields? disabled_fields, o.to_s }
    end

    %i(groupable inline block available_inline available_block available_totalable).each do |prefix|
      define_method "#{prefix}_columns" do
        columns = super()
        disabled_fields = project.present? ? project.disabled_core_fields : []
        columns.reject{|o| name_matches_disabled_fields? disabled_fields, o.name.to_s }
      end
    end
  end
end

Query.send(:prepend, RedmineCustomizeCoreFields::Query)
