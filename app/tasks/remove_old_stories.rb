class RemoveOldStories
  def initialize(limit = 9000)
    @limit = limit
  end

  def remove_all
    stories.map(&:destroy)
  end

  private

  def stories
    @stories ||=
      Story.
      where(is_starred: false).
      order(:published).
      first(Story.count - @limit)
  end
end
