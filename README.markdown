# Resouce Representations

Rails helpers, including form builders are great to allow rapid development of applications and views.

They are procedural in nature and have hard time to adapt to complex models. They also live in a single namespace making it difficult to find which helpers apply to which models.

Resource representations change syntax to object oriented and model specific.

## Example usage

Rails helpers:

    - form_for(user) do |f|
      login:
      = h(user.login)
      = f.label(:email, "Email")
      = f.text_field(:email)
      - fields_for(user.profile) do |p|
        Full name:
        = h(full_name(p))
        = f.label(:first_name, "First name")
        = f.text_field(:first_name)
        = f.label(:last_name, "Last name")
        = f.text_field(:last_name)
      = f.submit("Submit")

Resource Representations

    - user = r(user)
    - user.form do
      login:
      = user.login
      = user.email.label
      = user.email.text_field
      