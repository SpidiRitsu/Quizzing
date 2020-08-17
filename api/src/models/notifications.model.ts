import {Entity, model, property, belongsTo} from '@loopback/repository';
import {Users} from './users.model';

@model({
  settings: {
    foreignKeys: {
      'Notifications-UserId-FK': {
        name: 'Notifications-UserId-FK',
        foreignKey: 'userId',
        entityKey: 'id',
        entity: 'Users',
      },
    },
  },
})
export class Notifications extends Entity {
  @property({
    type: 'number',
    id: true,
    generated: true,
  })
  id?: number;

  @property({
    type: 'string',
    required: true,
  })
  content: string;

  @property({
    type: 'date',
  })
  dateCreated?: string;

  @belongsTo(() => Users, {}, {required: true})
  userId: number;

  constructor(data?: Partial<Notifications>) {
    super(data);
  }
}

export interface NotificationsRelations {
  // describe navigational properties here
}

export type NotificationsWithRelations = Notifications & NotificationsRelations;
