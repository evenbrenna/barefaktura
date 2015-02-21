# Actions related to clients
class ClientsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @clients = current_user.clients
  end

  def show
    @client = current_user.clients.find(params[:id])
    @invoices = @client.invoices
  end

  def new
    @client = current_user.clients.new
  end

  def create
    @client = current_user.clients.new(client_params)
    if @client.save
      redirect_to clients_path, :notice => 'Kunde Opprettet!'
    else
      render 'new'
    end
  end

  def edit
    @client = current_user.clients.find(params[:id])
  end

  def update
    @client = current_user.clients.find(params[:id])
    if @client.update(client_params)
      redirect_to clients_path, :notice => 'Kunde Oppdatert'
    else
      render 'edit'
    end
  end

  def destroy
    client = current_user.clients.find(params[:id])
    begin
      client.destroy
      flash[:notice] = 'Kunde slettet'
    rescue
      flash[:alert] = 'Du kan ikke slette en kunde som har motatt fakturaer'
    end
    redirect_to clients_path
  end

  def client_json
    client = current_user.clients.find(params[:id])
    render :json => client
  end

  private

  def client_params
    params.require(:client).permit(:name, :address, :delivery_address,
                                   :email, :user_id, :ref, :org_nr)
  end
end
