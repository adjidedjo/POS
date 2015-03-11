class AddRegexToSupervisorExhibition < ActiveRecord::Migration
  def change
    add_column :supervisor_exhibitions, :regex, :string
  end
end
