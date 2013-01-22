module RedmineSpentTimeColumn
  module Patches
    module IssuePatch
      
      def calculated_spent_hours
        @calculated_spent_hours ||= self_and_descendants.sum("estimated_hours * done_ratio / 100").to_f || 0.0
      end
      
      def divergent_hours
        @divergent_hours ||= spent_hours - calculated_spent_hours
      end
      
      def calculated_remaining_hours
        @calculated_remaining_hours ||= self_and_descendants.sum("estimated_hours - (estimated_hours * done_ratio / 100)").to_f || 0.0
      end
      
      def aggregated_spent_hours
        @aggregated_spent_hours ||= TimeEntry.find_all_by_issue_id(self_and_descendants.collect{ |i| i.id }).collect { |t| t.hours }.inject(:+).to_f || 0.0
      end
      
      def aggregated_divergent_hours
        @aggregated_remaining_hours ||= (aggregated_spent_hours - self_and_descendants.sum("estimated_hours * done_ratio / 100").to_f) || 0.0
      end
      
    end
  end
end