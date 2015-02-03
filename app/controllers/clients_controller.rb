class ClientsController < ApplicationController

    before_action :authenticate_user!

    def index
        @clients = current_user.clients.all
        @user = current_user
    end

    def show
        @client = current_user.clients.find(params[:id])
        @invoices = @client.invoices.all.except(:order).order('invoice_number DESC')
        @total_invoiced = @client.total_invoiced

    end

    def new
        @client = current_user.clients.new
    end

    def create
        @client = current_user.clients.new(client_params)

        if @client.save
            redirect_to clients_path, :notice => "Kunde Opprettet!"
        else
            render "new"
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
        @client = current_user.clients.find(params[:id])

        begin
            @client.destroy
            flash[:notice] = 'Kunde slettet'
        rescue
            flash[:alert] = "Feil: Du kan ikke slette en kunde som har motatt fakturaer"
        end
        redirect_to clients_path
    end

    def get_json
        client = current_user.clients.find(params[:id])
        render :text => client.to_json
    end

    private
        def client_params
            params.require(:client).permit(:name, :address, :delivery_address, :email, :user_id, :ref, :org_nr)
        end

end
