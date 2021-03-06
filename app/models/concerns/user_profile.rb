# This module contains all the profile-related methods of a User.
#
concern :UserProfile do

  included do
    include HasProfile
  end

  def landline_profile_fields
    phone_profile_fields - mobile_phone_profile_fields
  end
  def mobile_phone_profile_fields
    phone_profile_fields.select do |field|
      field.label.downcase.include?('mobil') or field.label.downcase.include?('handy')
    end
  end

  def phone
    if landline_profile_fields.first.try(:value).present?
      landline_profile_fields.first.value
    else
      mobile
    end
  end
  def phone=(new_number)
    (landline_profile_fields.first || profile_fields.create(label: I18n.t(:phone), type: 'ProfileFields::Phone')).update_attributes(value: new_number)
  end
  def phone_field
    landline_profile_fields.first || phone_profile_fields.first
  end

  def mobile
    (mobile_phone_profile_fields + phone_profile_fields).first.try(:value)
  end
  def mobile=(new_number)
    (mobile_phone_profile_fields.first || profile_fields.create(label: I18n.t(:mobile), type: 'ProfileFields::Phone')).update_attributes(value: new_number)
  end

  def profile_field_by_label(label)
    profile_fields.where(label: label).first
  end
  def profile_field_value(label)
    profile_field_by_label(label).try(:value).try(:strip)
  end

  def personal_title_field
    profile_field_by_label 'personal_title'
  end
  def personal_title
    personal_title_field.try(:value).try(:strip)
  end
  def personal_title=(new_value)
    profile_fields.where(label: 'personal_title').first_or_create.update_attributes value: new_value
  end

  def academic_degree_field
    profile_field_by_label 'academic_degree'
  end
  def academic_degree
    academic_degree_field.try(:value).try(:strip)
  end
  def academic_degree=(new_value)
    profile_fields.where(label: 'academic_degree').first_or_create.update_attributes value: new_value
  end


  def study_fields
    profile_fields.where(type: 'ProfileFields::Study')
  end
  def primary_study_field
    (study_fields_not_finished + study_fields).first
  end
  def study_fields_not_finished
    study_fields.select { |study| study.to.blank? }
  end

  def name_surrounding_profile_field
    profile_fields.where(type: "ProfileFields::NameSurrounding").first
  end
  def text_above_name
    name_surrounding_profile_field.try(:text_above_name).try(:strip)
  end
  def text_below_name
    name_surrounding_profile_field.try(:text_below_name).try(:strip)
  end
  def text_before_name
    name_surrounding_profile_field.try(:name_prefix).try(:strip)
  end
  def text_after_name
    name_surrounding_profile_field.try(:name_suffix).try(:strip)
  end


  def fill_in_template_profile_information
    self.profile_fields.create(label: :personal_title, type: "ProfileFields::General")
    self.profile_fields.create(label: :academic_degree, type: "ProfileFields::AcademicDegree")

    self.profile_fields.create(label: :work_address, type: "ProfileFields::Address")
    self.profile_fields.create(label: :phone, type: "ProfileFields::Phone") unless self.phone
    self.profile_fields.create(label: :mobile, type: "ProfileFields::Phone") unless self.mobile
    self.profile_fields.create(label: :fax, type: "ProfileFields::Phone")
    self.profile_fields.create(label: :homepage, type: "ProfileFields::Homepage")

    pf = self.profile_fields.build(label: :bank_account, type: "ProfileFields::BankAccount")
    pf.becomes(ProfileFields::BankAccount).save

    pf = self.profile_fields.create(label: :name_field, type: "ProfileFields::NameSurrounding")
      .becomes(ProfileFields::NameSurrounding)
    pf.text_above_name = ""; pf.name_prefix = "Herrn"; pf.name_suffix = ""; pf.text_below_name = ""
    pf.save
  end

  class_methods do
    def profile_section_titles
      [:contact_information, :about_myself, :study_information, :career_information,
        :organizations, :bank_account_information]
    end
  end

end