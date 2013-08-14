class Sprints < Version
  unloadable

  validate :start_and_end_dates

  class << self
    def open_sprints(project = nil)
      if project
        scoped(:order => 'ir_start_date ASC, ir_end_date ASC', :conditions => [ "status = 'open' and (project_id = ? OR sharing = 'system')", project.id])
      else
        scoped(:order => 'ir_start_date ASC, ir_end_date ASC', :conditions => [ "status = 'open'"])
      end
    end
    def all_sprints(project = nil)
      if project
        scoped(:order => 'ir_start_date ASC, ir_end_date ASC', :conditions => [ "project_id = ? OR sharing = 'system'", project.id ])
      else
        scoped(:order => 'ir_start_date ASC, ir_end_date ASC')
      end
    end
  end

  def start_and_end_dates
    errors.add_to_base("Sprint cannot end before it starts") if self.ir_start_date && self.ir_end_date && self.ir_start_date >= self.ir_end_date
  end

  def tasks
    SprintsTasks.get_tasks_by_sprint(self.project, self.id)
  end

end