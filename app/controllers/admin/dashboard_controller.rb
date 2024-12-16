module Admin
  class DashboardController < ApplicationController
    # Autentica o usuário e verifica se tem a role de admin
    before_action :authenticate_user!
    before_action :check_admin_role

    def index
      @payments = Payment.all.order(created_at: :desc)
    end

    private

    # Verifica se o usuário é admin
    def check_admin_role
      unless current_user.admin?
        flash[:alert] = "Você não tem permissão para acessar esta página"
        redirect_to root_path # Ou outra página de sua escolha
      end
    end
  end
end
