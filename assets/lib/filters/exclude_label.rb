module Filters
  class ExcludeLabel
    def initialize(pull_requests:, input: Input.instance)
      @pull_requests = pull_requests
      @input = input
    end

    def pull_requests
      if @input.source.exclude_label
        @memoized ||= @pull_requests.select do |pr|
          issue  = Octokit.issue(@input.source.repo, pr.id)
          labels = issue[:labels] || []
          labels.find { |l| l['name'].to_s.casecmp(@input.source.exclude_label.to_s.downcase).nonzero? }
        end
      else
        @pull_requests
      end
    end
  end
end
