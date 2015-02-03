ActiveAdmin.register User do


  permit_params :email,
                :password,
                :password_confirmation,
                :role,
                :name,
                :ref,
                :address,
                :phone,
                :org_number,
                :bank_name,
                :bank_account,
                :bank_swift,
                :bank_iban,
                :mva_reg,
                :foretaks_reg,
                :next_invoice_number

    index do
        selectable_column
        column :name
        column :email
        column :current_sign_in_at
        column :last_sign_in_at
        column :sign_in_count
        column :ref
        column :address
        column :phone
        column :org_number
        column :bank_name
        column :bank_account
        column :bank_swift
        column :bank_iban
        column :role
        column :mva_reg
        column :foretaks_reg
        column :next_invoice_number
        actions
    end

    filter :email

    form do |f|
        f.inputs "User Details" do
            f.input :name
            f.input :email
            f.input :password
            f.input :password_confirmation
            f.input :role, as: :radio, collection: {User: "user", Administrator: "administrator"}
            f.input :ref
            f.input :address
            f.input :phone
            f.input :org_number
            f.input :bank_name
            f.input :bank_account
            f.input :bank_swift
            f.input :bank_iban
            f.input :mva_reg
            f.input :foretaks_reg
            f.input :next_invoice_number
        end
        f.actions
    end
end
