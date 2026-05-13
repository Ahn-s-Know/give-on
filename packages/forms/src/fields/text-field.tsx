"use client";

import { Input } from "@give-on/ui";
import { FieldValues, Path, UseFormRegister } from "react-hook-form";

type TextFieldProps<TFieldValues extends FieldValues> = {
  label: string;
  name: Path<TFieldValues>;
  register: UseFormRegister<TFieldValues>;
  placeholder?: string;
};

export function TextField<TFieldValues extends FieldValues>({
  label,
  name,
  register,
  placeholder
}: TextFieldProps<TFieldValues>) {
  return (
    <label className="flex flex-col gap-2 text-sm font-medium">
      <span>{label}</span>
      <Input {...register(name)} placeholder={placeholder} />
    </label>
  );
}

