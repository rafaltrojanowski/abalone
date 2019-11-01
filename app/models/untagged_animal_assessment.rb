# rubocop:disable Lint/UnneededCopDisableDirective, Metrics/LineLength
# == Schema Information
#
# Table name: untagged_animal_assessments
#
#  id                :bigint           not null, primary key
#  raw               :boolean          default(TRUE), not null
#  measurement_date  :date
#  cohort            :string
#  spawning_date     :date
#  growout_rack      :decimal(, )
#  growout_column    :string
#  growout_trough    :decimal(, )
#  length            :decimal(, )
#  mass              :decimal(, )
#  gonad_score       :decimal(, )
#  predicted_sex     :string
#  notes             :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  processed_file_id :integer
#
# rubocop:enable Metrics/LineLength, Lint/UnneededCopDisableDirective

class UntaggedAnimalAssessment < ApplicationRecord
  HEADERS = {
    MEASUREMENT_DATE: "Measurement_date",
    COHORT: "Cohort",
    SPAWNING_DATE: "Spawning_date",
    GROWOUT_RACK: "Growout_Rack",
    GROWOUT_COLUMN: "Growout_Column",
    GROWOUT_TROUGH: "Growout_Trough",
    LENGTH: "Length", # (mm)
    MASS: "Mass", # (g)
    GONAD_SCORE: "Gonad Score",
    PREDICTED_SEX: "Predicted Sex",
    NOTES: "Notes"
  }

  validates(
    :measurement_date,
    :cohort,
    :spawning_date,
    :growout_trough,
    :growout_rack,
    :growout_column,
    :length, presence: true
  )
  validates :length, numericality: true

  # Cohort is translated to shl_case_number to compute stats.
  # Here we need to transfer it back to be able to store value in the DB.
  def shl_case_number=(value)
    self.cohort = value
  end

  def measurement_date=(measurement_date_str)
    return unless measurement_date_str
    write_attribute(:measurement_date, DateTime.strptime(measurement_date_str, '%m/%d/%y'))
  end

  def spawning_date=(spawning_date_str)
    return unless spawning_date_str
    write_attribute(:spawning_date, DateTime.strptime(spawning_date_str, '%m/%d/%y'))
  end

  def self.lengths_for_measurement(processed_file_id)
    select(:length).where(processed_file_id: processed_file_id).map { |record| record.length.to_f }
  end

  def cleanse_data!
    # Do nothing
  end
end
