# frozen_string_literal: true

Rails.application.routes.draw do
  get "/preview", to: "previews#new"
  post "/preview", to: "previews#create"
end
