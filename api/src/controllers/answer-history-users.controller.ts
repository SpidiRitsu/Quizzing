import {repository} from '@loopback/repository';
import {param, get, getModelSchemaRef} from '@loopback/rest';
import {AnswerHistory, Users} from '../models';
import {AnswerHistoryRepository} from '../repositories';

export class AnswerHistoryUsersController {
  constructor(
    @repository(AnswerHistoryRepository)
    public answerHistoryRepository: AnswerHistoryRepository,
  ) {}

  @get('/answer-histories/{id}/users', {
    responses: {
      '200': {
        description: 'Users belonging to AnswerHistory',
        content: {
          'application/json': {
            schema: {type: 'array', items: getModelSchemaRef(Users)},
          },
        },
      },
    },
  })
  async getUsers(
    @param.path.number('id') id: typeof AnswerHistory.prototype.id,
  ): Promise<Users> {
    return this.answerHistoryRepository.user(id);
  }
}
