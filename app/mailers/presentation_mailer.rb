class PresentationMailer < ActionMailer::Base
  default from: "paperoo@ipads.sjtu.edu.cn"

  def notification(pres)
    @pres = pres
    mail(to: pres.account.email,
         subject: "Upcoming paper presentation")
  end
end
