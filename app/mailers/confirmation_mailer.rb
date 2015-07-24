class ConfirmationMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  #default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

  def confirmation_instructions(record, token, opts={})
    # Creates a url that looks like:
    # http://localhost:3000/users/confirmation?confirmation_token=Rqzr178VVDWgTmKrpPjF
    confirm_url = user_confirmation_url(format: :json, confirmation_token: token)

    # TODO: Create an email with a link to your front end's confirmation page, passing the token.  Your front end page can then make the request to devise's users confirmation endpoint
    # TODO: Render email as html instead of text
    body = "<a href='#{confirm_url}'>Click here to confirm.</a>"
    opts[:body] = body
    super
  end
end
