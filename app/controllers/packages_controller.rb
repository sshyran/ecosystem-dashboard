class PackagesController < ApplicationController
  def index
    @scope = Package.where(repository_id: Repository.internal.pluck(:id)).includes(:repository)
    @pagy, @packages = pagy(@scope.order('collab_dependent_repos_count DESC, dependent_repos_count DESC, created_at DESC'))
  end

  def show
    @package = Package.find(params[:id])
    direct = params[:direct] == 'false' ? false : true
    @repository_dependencies = @package.repository_dependencies.external.where(direct: direct).active.source.includes(:repository, :manifest)
  end

  def search
    @scope = Package.search_by_name(params[:query]).includes(:repository)
    @pagy, @packages = pagy(@scope)
  end

  def outdated
    @packages = Package.internal.where('outdated > 0').where('collab_dependent_repos_count > 0').order('collab_dependent_repos_count DESC').includes(:repository)
  end
end
