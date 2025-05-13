import { Entity, Column, PrimaryGeneratedColumn } from "typeorm";

@Entity()
export class Product {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  display_name: string;

  @Column()
  price: number;

  @Column({ default: true })
  is_active: boolean;
}
