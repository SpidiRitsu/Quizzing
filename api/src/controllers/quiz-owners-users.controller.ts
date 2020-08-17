import {repository} from '@loopback/repository';
import {param, get, getModelSchemaRef} from '@loopback/rest';
import {QuizOwners, Users} from '../models';
import {QuizOwnersRepository} from '../repositories';

export class QuizOwnersUsersController {
  constructor(
    @repository(QuizOwnersRepository)
    public quizOwnersRepository: QuizOwnersRepository,
  ) {}

  @get('/quiz-owners/{id}/users', {
    responses: {
      '200': {
        description: 'Users belonging to QuizOwners',
        content: {
          'application/json': {
            schema: {type: 'array', items: getModelSchemaRef(Users)},
          },
        },
      },
    },
  })
  async getUsers(
    @param.path.number('id') id: typeof QuizOwners.prototype.id,
  ): Promise<Users> {
    return this.quizOwnersRepository.owner(id);
  }
}
