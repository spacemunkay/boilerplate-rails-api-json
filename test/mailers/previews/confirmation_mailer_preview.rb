class ConfirmationMailerPreview < ActionMailer::Preview

  def confirmation_instructions
    ConfirmationMailer.confirmation_instructions(User.first, "faketoken", {})
  end
end
