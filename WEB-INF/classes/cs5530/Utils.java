package cs5530;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Map;

/**
 * Created by greg on 3/17/16.
 */
public class Utils {

    public static String getUserInput(QuestionSizePair questionSizePair, boolean isNumber) {
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        String input;
        while (true) {
            System.out.print(questionSizePair.question);
            try {
                while ((input = in.readLine()) == null && input.length() == 0);

                if (isNumber)
                    Long.parseLong(input);
                else
                    if (input.length() > questionSizePair.maxSize)
                        continue;
            } catch (IOException e) {
                System.out.println();
                continue;
            } catch (NumberFormatException e) {
                System.out.println(questionSizePair.errorMessage);
                continue;
            }
            System.out.println();
            break;
        }

        return input;
    }

    public static String getDollarAmount(QuestionSizePair questionSizePair) {
        String number;
        while (true) {
            number = Utils.getUserInput(questionSizePair, false);
            if (number.charAt(0) == '$') {
                if (number.length() == 1) {
                    System.out.println(questionSizePair.errorMessage);
                    continue;
                }
                number = number.substring(1);
            }
            try {
                Integer.parseInt(number);
                return number;
            } catch (NumberFormatException e) {
                System.out.println(questionSizePair.errorMessage);
                continue;
            }
        }
    }

    static class QuestionSizePair {
        public String question;
        public int maxSize;
        public String errorMessage;

        public QuestionSizePair(String question, int maxSize) {
            this.question = question;
            this.maxSize = maxSize;
            this.errorMessage = "Invalid error message";
        }

        public QuestionSizePair(String question, int maxSize, String errorMessage) {
            this.question = question;
            this.maxSize = maxSize;
            this.errorMessage = errorMessage;
        }
    }
}
