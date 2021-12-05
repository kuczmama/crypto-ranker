class ApiController < ApplicationController
    def projects
        projects = ['project1', 'project2', 'project3']
        render json: projects
    end
end
