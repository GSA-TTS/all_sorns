# Overwrites the the methods at https://github.com/Casecommons/pg_search/blob/master/lib/pg_search/features/tsearch.rb
# This adds in the ability to use postgres built in phrase searching.
# There is a similar PR open at https://github.com/Casecommons/pg_search/pull/417
# If this feature is ever added to the gem in the future, remove this monkey patch and use their implenentation.

module PgSearch
  module Features
    class TSearch
      def self.valid_options
        super + %i[dictionary prefix negation any_word phrase normalization tsvector_column highlight]
      end

      def tsquery
        return "''" if query.blank?

        query_terms = query.split(" ").compact
        tsquery_terms = query_terms.map { |term| tsquery_for_term(term) }
        tsquery_terms.join(options[:any_word] ? ' || ' : ' && ')
        join_op =
          if options[:any_word]
            ' || '
          elsif options[:phrase]
            ' <-> '
          else
            ' && '
          end
        tsquery_terms.join(join_op)
      end
    end
  end
end