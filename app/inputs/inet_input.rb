class InetInput < Formtastic::Inputs::StringInput

    # Fixes issue where Formtastic forms in ActiveAdmin
    # raises error because of Inet input type for ip addresses

end