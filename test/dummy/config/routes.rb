# frozen_string_literal: true

Rails.application.routes.draw do
  get "/preview", to: "previews#new"
  get "/preview/hostile", to: "previews#hostile"
  post "/preview", to: "previews#create"
end
