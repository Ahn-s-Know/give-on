import { zodResolver } from "@hookform/resolvers/zod";
import { useForm, type DefaultValues, type UseFormProps } from "react-hook-form";
import { z, type ZodTypeAny } from "zod";

type UseZodFormOptions<TSchema extends ZodTypeAny> = {
  schema: TSchema;
  defaultValues?: DefaultValues<z.infer<TSchema>>;
  options?: Omit<UseFormProps<z.infer<TSchema>>, "resolver" | "defaultValues">;
};

export function useZodForm<TSchema extends ZodTypeAny>({
  schema,
  defaultValues,
  options
}: UseZodFormOptions<TSchema>) {
  return useForm<z.infer<TSchema>>({
    resolver: zodResolver(schema),
    defaultValues,
    ...options
  });
}

