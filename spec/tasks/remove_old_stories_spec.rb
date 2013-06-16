require "spec_helper"
require "support/active_record"

app_require "tasks/remove_old_stories"

describe RemoveOldStories do
  describe "#remove_all" do
    it "destroys each matched story" do
      story = stub(:story)
      story.should_receive(:destroy)
      described_class.any_instance.stub(stories: [story])
      described_class.new.remove_all
    end
  end

  describe "#stories" do
    it "only returns unstarred stories" do
      story1 = Story.create!(permalink: "foo")
      story2 = Story.create!(permalink: "bar", is_starred: true)
      stories = described_class.new.send(:stories)
      stories.should include story1
      stories.should_not include story2
    end

    it "returns old stories that exceed the limit" do
      story1 = Story.create!(permalink: "story1", published: 1.day.ago)
      story2 = Story.create!(permalink: "story2", published: 2.days.ago)
      story3 = Story.create!(permalink: "story3", published: 3.days.ago)
      stories = described_class.new(2).send(:stories)
      stories.should == [story3]
    end
  end
end
