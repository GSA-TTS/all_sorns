require 'rails_helper'

RSpec.describe SornsController, type: :controller do
  before { create :sorn }
  it do
    get :search, params: {fields: [:categories_of_record], search: "email telephone"}

  end


end