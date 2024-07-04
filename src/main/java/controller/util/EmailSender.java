package controller.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class EmailSender {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final int SMTP_PORT = 587;
    private static final String SMTP_USERNAME = "hoangnq417@gmail.com";
    private static final String SMTP_PASSWORD = "nkcxtcuengbweqbq";

    public static boolean sendEmail(String to, String subject, String body) {
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        // Cấu hình khác tùy thuộc vào nhà cung cấp dịch vụ email

        Session mailSession = Session.getInstance(props, new jakarta.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USERNAME, SMTP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(mailSession);
            message.addHeader("Content-type", "text/html;charset=UTF-8");
            message.setFrom(new InternetAddress(SMTP_USERNAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setText(body);

            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
}
