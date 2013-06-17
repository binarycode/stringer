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
      stories = described_class.new(0).send(:stories)
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

  describe "#count" do
    before { Story.stub(count: 100) }
    let(:task) { described_class.new(limit) }

    context "when number of stories exceed limit" do
      let(:limit) { 80 }
      it "returns difference between story number and limit" do
        task.send(:count).should == 20
      end
    end

    context "when number of stories is less than limit" do
      let(:limit) { 110 }
      it "returns zero" do
        task.send(:count).should == 0
      end
    end
  end
end
