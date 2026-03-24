#define _POSIX_C_SOURCE 200809L

#include <libgen.h>
#include <stdio.h>
#include <unistd.h>

#include <gmp.h>

#include "baseconv.g.h"
#include "baseconv.l.h"

static char *progname;
static int status;

static struct gengetopt_args_info args;

int
main(int argc, char *argv[])
{
	unsigned int i;
	mpz_t num;
	
	progname = basename(argv[0]);
	mpz_init(num);

	if (ggo(argc, argv, &args))
		return 1;

	if (args.help_given)
	{
		ggo_print_help();
		return 0;
	}
	if (args.version_given)
	{
		ggo_print_version();
		return 0;
	}

	args.output_base_arg = ((abs(args.output_base_arg) > 2) && (abs(args.output_base_arg) <= 36)) ? -args.output_base_arg : args.output_base_arg;

	if ((abs(args.input_base_arg) < 2) || (args.input_base_arg < -36) || (args.input_base_arg > 62))
	{
		fprintf(stderr, "%s: %d: Invalid input base\n", progname, args.input_base_arg);
		return 1;
	}
	
	if ((abs(args.output_base_arg) < 2) || (args.output_base_arg < -36) || (args.output_base_arg > 62))
	{
		fprintf(stderr, "%s: %d: Invalid output base\n", progname, args.output_base_arg);
		return 1;
	}
	
	if (args.inputs_num)
	{
		for (i=0; i<args.inputs_num; i++)
		{
			if (mpz_set_str(num, args.inputs[i], args.input_base_arg) || (mpz_cmp_d(num, 0) < 0))
			{
				if (!args.silent_given)
					fprintf(stderr, "%s: %s: Bad argument\n", progname, args.inputs[i]);

				status = 1;
				continue;
			}

			if (!args.quiet_given)
				printf("%s: ", args.inputs[i]);
			mpz_out_str(NULL, args.output_base_arg, num);
			putchar('\n');
		}
	}
	else
	{
		while (yylex() != -1)
		{
			if ((errno < 0) || mpz_set_str(num, yytext, args.input_base_arg) || (mpz_cmp_d(num, 0) < 0))
			{
				if (!args.silent_given)
					fprintf(stderr, "%s: %s: Bad argument\n", progname, yytext);

				errno = 0;
				status = 1;
				continue;
			}

			if (!args.quiet_given)
				printf("%s: ", yytext);
			mpz_out_str(NULL, args.output_base_arg, num);
			putchar('\n');
		}
	}

	return args.loose_exit_status_given ? 0 : status;
}
