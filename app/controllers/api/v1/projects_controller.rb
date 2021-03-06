# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < ApplicationController
      protect_from_forgery with: :null_session

      def index
        projects = Project.where(user_id: User.first.uid)
        render json: projects
      end

      def show
        project = Project.find_by(repo_id: params[:id])
        if project
          render json: project
        else
          render json: { error: 'Not found' }, status: :not_found
        end
      end

      def logs
        project = Project.find_by(repo_id: params[:id])
        if project
          render json: project.logs
        else
          render json: { error: 'Not found' }, status: :not_found
        end
      end

      def info
        project = Project.find_by(repo_id: params[:id])
        if project
          render json: project.status
        else
          render json: { error: 'Not found' }, status: :not_found
        end
      end

      def create
        project = Project.new(
          user_id: User.first.uid,
          repo_id: params[:repo_id]
        )
        if project.valid?
          project.save!
          project.set_webhook
          render json: project
        else
          render json: { error: 'Bad Request' }, status: :bad_request
        end
      end

      def destroy
        project = Project.find_by(repo_id: params[:id])
        if project
          project.delete
          render json: { message: 'Success' }
        else
          render json: { error: 'Not found' }, status: :not_found
        end
      end
    end
  end
end
