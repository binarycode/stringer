class RemoveOldStories
  def initialize(limit = 9000)
    @limit = limit.to_i
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
      first(count)
  end

  def count
    [Story.count - @limit, 0].max
  end
end
