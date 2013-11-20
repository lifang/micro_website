#encoding: utf-8
class RegistrationsController < Devise::RegistrationsController

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    if resource.update_with_password_copy(resource_params)
      if is_navigational_format?
        if resource.respond_to?(:pending_reconfirmation?) && resource.pending_reconfirmation?
          flash_key = :update_needs_confirmation
        end
        set_flash_message :notice, flash_key || :updated
      end
      sign_in resource_name, resource, :bypass => true
      @notice = "更新成功！"
      @path = after_update_path_for(resource)
      render :success
      #respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords resource
      @notice = "更新失败！ #{resource.errors.messages.values.flatten.join("\\n")}"
      render :fail
      #respond_with resource
    end
  end
end