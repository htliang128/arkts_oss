export default class DateUtil {
  public static formatRfc822Date(date: Date): string {
    return DateUtil.getRfc822DateFormat(date);
  }

  public static getRfc822DateFormat(date: Date): string {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    const day = days[date.getUTCDay()];
    const dayOfMonth = date.getUTCDate();
    const month = months[date.getUTCMonth()];
    const year = date.getUTCFullYear();
    const hours = date.getUTCHours();
    const minutes = date.getUTCMinutes();
    const seconds = date.getUTCSeconds();

    const timeZone = "GMT";

    return `${day}, ${dayOfMonth} ${month} ${year} ${hours}:${minutes}:${seconds} ${timeZone}`;
  }

  public static parseRfc822Date(dateString: string): Date {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    const parts = dateString.split(' ');
    const day = parseInt(parts[1], 10);
    const month = months.indexOf(parts[2]);
    const year = parseInt(parts[3], 10);
    const timeParts = parts[4].split(':');
    const hours = parseInt(timeParts[0], 10);
    const minutes = parseInt(timeParts[1], 10);
    const seconds = parseInt(timeParts[2], 10);

    const date = new Date(Date.UTC(year, month, day, hours, minutes, seconds));

    return date;
  }

  public static formatIso8601Date(date: Date): string {
    if (!(date instanceof Date)) {
      date = new Date(date);
    }

    return date.toISOString();
  }

  public static formatAlternativeIso8601Date(date: Date): string {
    if (!(date instanceof Date)) {
      date = new Date(date);
    }

    const year = date.getUTCFullYear();
    const month = String(date.getUTCMonth() + 1).padStart(2, '0');
    const day = String(date.getUTCDate()).padStart(2, '0');
    const hours = String(date.getUTCHours()).padStart(2, '0');
    const minutes = String(date.getUTCMinutes()).padStart(2, '0');
    const seconds = String(date.getUTCSeconds()).padStart(2, '0');

    return `${year}-${month}-${day}T${hours}:${minutes}:${seconds}Z`;
  }

  public static parseIso8601Date(dateString: string): Date {
    const dateRegexWithMillis = /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})\.(\d{3})Z$/;
    const dateRegexWithoutMillis = /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})Z$/;

    let match = dateString.match(dateRegexWithMillis);
    if (!match) {
      match = dateString.match(dateRegexWithoutMillis);
    }

    if (match) {
      const matchArray = match.slice(1).map(Number);
      const year = matchArray[0];
      const month = matchArray[1];
      const day = matchArray[2];
      const hour = matchArray[3];
      const minute = matchArray[4];
      const second = matchArray[5];
      const millisecond = matchArray[6] || 0;

      return new Date(Date.UTC(year, month - 1, day, hour, minute, second, millisecond));
    } else {
      throw new Error('Invalid ISO 8601 date format');
    }
  }
}