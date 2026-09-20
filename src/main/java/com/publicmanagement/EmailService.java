package com.publicmanagement;

import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailService {

    private static final String MAIL_USERNAME =
            System.getenv("MAIL_USERNAME");

    private static final String MAIL_PASSWORD =
            System.getenv("MAIL_PASSWORD");

    private static final String MAIL_FROM =
            System.getenv("MAIL_FROM");

    public static boolean sendOtp(String recipientEmail, String otp) {

        try {
            Properties properties = new Properties();

            properties.put("mail.smtp.host", "smtp.gmail.com");
            properties.put("mail.smtp.port", "587");
            properties.put("mail.smtp.auth", "true");
            properties.put("mail.smtp.starttls.enable", "true");

            Session session = Session.getInstance(
                    properties,
                    new Authenticator() {
                        @Override
                        protected PasswordAuthentication getPasswordAuthentication() {
                            return new PasswordAuthentication(
                                    MAIL_USERNAME,
                                    MAIL_PASSWORD.replaceAll("\\s+", "")
                            );
                        }
                    }
            );

            Message message = new MimeMessage(session);

            message.setFrom(new InternetAddress(MAIL_FROM));
            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(recipientEmail)
            );

            message.setSubject(
                    "Public Management System - Email Verification OTP"
            );

            String emailBody =
                    "Dear Citizen,\n\n"
                    + "Your OTP for Public Management System email verification is:\n\n"
                    + otp
                    + "\n\n"
                    + "This OTP is valid for 10 minutes.\n\n"
                    + "Please do not share this OTP with anyone.\n\n"
                    + "Regards,\n"
                    + "Public Management System";

            message.setText(emailBody);

            Transport.send(message);

            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}